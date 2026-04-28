#!/usr/bin/env python3
"""
IBA World Cocktails Scraper
Extrae nombre, imagen, ingredientes, garnish y método de todos los cócteles de iba-world.com
"""

import time
import re
import sys
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError
from html.parser import HTMLParser

BASE_URL = "https://iba-world.com"
ALL_COCKTAILS_URL = "https://iba-world.com/cocktails/all-cocktails/"
OUTPUT_FILE = "iba_cocktails.txt"
DELAY = 1.0  # segundos entre requests (respetar al servidor)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (compatible; IBA-Scraper/1.0)",
    "Accept-Language": "en-US,en;q=0.9",
}


def fetch(url: str) -> str:
    """Hace un GET y devuelve el HTML como string."""
    req = Request(url, headers=HEADERS)
    try:
        with urlopen(req, timeout=15) as resp:
            return resp.read().decode("utf-8", errors="replace")
    except HTTPError as e:
        print(f"  [HTTP {e.code}] {url}", file=sys.stderr)
        return ""
    except URLError as e:
        print(f"  [URLError] {url}: {e.reason}", file=sys.stderr)
        return ""


# ---------------------------------------------------------------------------
# Parser: galería de cócteles (lista de tarjetas con link e imagen)
# ---------------------------------------------------------------------------

class GalleryParser(HTMLParser):
    """Extrae (url, imagen) de cada tarjeta de cóctel en la galería."""

    def __init__(self):
        super().__init__()
        self.cocktails: list[dict] = []      # [{url, image}]
        self._in_card_link = False
        self._current_url = None
        self._current_image = None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "a":
            href = attrs.get("href", "")
            if "/iba-cocktail/" in href:
                self._in_card_link = True
                self._current_url = href
                self._current_image = None
        if tag == "img" and self._in_card_link:
            # Preferir src; a veces está en data-src (lazy load)
            src = attrs.get("src") or attrs.get("data-src") or ""
            if src and "logo" not in src and src.endswith((".webp", ".jpg", ".jpeg", ".png")):
                self._current_image = src

    def handle_endtag(self, tag):
        if tag == "a" and self._in_card_link:
            if self._current_url:
                self.cocktails.append({
                    "url": self._current_url,
                    "image": self._current_image or "",
                })
            self._in_card_link = False
            self._current_url = None
            self._current_image = None


def get_pagination_urls(html: str) -> list[str]:
    """Detecta las URLs de páginas adicionales de la galería."""
    pattern = re.compile(
        r'href="(https://iba-world\.com/cocktails/all-cocktails/page/(\d+)/)"'
    )
    pages = {}
    for m in pattern.finditer(html):
        pages[int(m.group(2))] = m.group(1)
    return list(pages.values())


def scrape_gallery() -> list[dict]:
    """Recorre todas las páginas de la galería y devuelve lista de {url, image}."""
    print("→ Scrapeando galería principal…")
    html = fetch(ALL_COCKTAILS_URL)
    if not html:
        return []

    parser = GalleryParser()
    parser.feed(html)
    cocktails = parser.cocktails

    extra_pages = sorted(
        get_pagination_urls(html),
        key=lambda u: int(re.search(r"/page/(\d+)/", u).group(1))
    )

    for page_url in extra_pages:
        print(f"  → Página {page_url}")
        time.sleep(DELAY)
        p_html = fetch(page_url)
        if not p_html:
            continue
        p_parser = GalleryParser()
        p_parser.feed(p_html)
        # Evitar duplicados
        seen = {c["url"] for c in cocktails}
        for c in p_parser.cocktails:
            if c["url"] not in seen:
                cocktails.append(c)
                seen.add(c["url"])

    print(f"  Total cócteles encontrados: {len(cocktails)}")
    return cocktails


# ---------------------------------------------------------------------------
# Parser: página individual de cóctel
# ---------------------------------------------------------------------------

class CocktailParser(HTMLParser):
    """Extrae nombre, ingredientes, método y garnish de una página de cóctel."""

    def __init__(self):
        super().__init__()
        self.name = ""
        self.ingredients: list[str] = []
        self.method = ""
        self.garnish = ""

        self._in_h1 = False
        self._current_section = None   # "Ingredients" | "Method" | "Garnish"
        self._in_li = False
        self._in_p = False
        self._in_h4 = False
        self._buffer = []
        self._method_parts: list[str] = []
        self._garnish_parts: list[str] = []

    # -- helpers
    def _flush(self) -> str:
        text = " ".join(" ".join(self._buffer).split())
        self._buffer = []
        return text

    def handle_starttag(self, tag, attrs):
        if tag == "h1":
            self._in_h1 = True
            self._buffer = []
        elif tag == "h4":
            self._in_h4 = True
            self._buffer = []
        elif tag == "li" and self._current_section == "Ingredients":
            self._in_li = True
            self._buffer = []
        elif tag == "p" and self._current_section in ("Method", "Garnish"):
            self._in_p = True
            self._buffer = []

    def handle_endtag(self, tag):
        if tag == "h1" and self._in_h1:
            self.name = self._flush()
            self._in_h1 = False
        elif tag == "h4" and self._in_h4:
            text = self._flush()
            self._in_h4 = False
            if "Ingredient" in text:
                self._current_section = "Ingredients"
            elif "Method" in text:
                self._current_section = "Method"
            elif "Garnish" in text:
                self._current_section = "Garnish"
            else:
                # Cualquier otro h4 (ej. "MOST VIEWED") cierra la sección actual
                self._current_section = None
        elif tag == "li" and self._in_li:
            text = self._flush()
            if text:
                self.ingredients.append(text)
            self._in_li = False
        elif tag == "p" and self._in_p:
            text = self._flush()
            if text:
                if self._current_section == "Method":
                    self._method_parts.append(text)
                elif self._current_section == "Garnish":
                    self._garnish_parts.append(text)
            self._in_p = False

    def handle_data(self, data):
        if self._in_h1 or self._in_h4 or self._in_li or self._in_p:
            self._buffer.append(data)

    def get_result(self) -> dict:
        return {
            "name": self.name,
            "ingredients": self.ingredients,
            "method": " ".join(self._method_parts).strip(),
            "garnish": " ".join(self._garnish_parts).strip(),
        }


def scrape_cocktail(url: str, image: str) -> dict:
    """Devuelve un dict con toda la info del cóctel."""
    html = fetch(url)
    if not html:
        return {}

    parser = CocktailParser()
    parser.feed(html)
    result = parser.get_result()
    result["url"] = url
    result["image"] = image
    return result


# ---------------------------------------------------------------------------
# Salida en texto plano
# ---------------------------------------------------------------------------

def format_cocktail(c: dict) -> str:
    lines = []
    lines.append("=" * 60)
    lines.append(f"NOMBRE: {c.get('name', 'N/A')}")
    lines.append(f"URL: {c.get('url', '')}")
    lines.append(f"IMAGEN: {c.get('image', '')}")
    lines.append("")
    lines.append("INGREDIENTES:")
    for ing in c.get("ingredients", []):
        lines.append(f"  - {ing}")
    lines.append("")
    lines.append(f"MÉTODO:\n  {c.get('method', 'N/A')}")
    lines.append("")
    lines.append(f"GARNISH:\n  {c.get('garnish', 'N/A')}")
    lines.append("")
    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    cards = scrape_gallery()
    if not cards:
        print("No se encontraron cócteles. Abortando.")
        return

    results = []
    for i, card in enumerate(cards, 1):
        print(f"[{i}/{len(cards)}] {card['url']}")
        data = scrape_cocktail(card["url"], card["image"])
        if data:
            results.append(data)
        time.sleep(DELAY)

    print(f"\n✓ Cócteles scrapeados: {len(results)}")
    print(f"→ Guardando en {OUTPUT_FILE}…")

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("IBA WORLD – CATÁLOGO DE CÓCTELES\n")
        f.write(f"Total: {len(results)} cócteles\n")
        f.write("=" * 60 + "\n\n")
        for c in results:
            f.write(format_cocktail(c))
            f.write("\n")

    print("✓ Listo.")


if __name__ == "__main__":
    main()