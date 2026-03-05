"""Example: Discovering buttons, links, and inputs on a page."""
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')

    buttons = page.locator('button').all()
    print(f"Found {len(buttons)} buttons:")
    for i, btn in enumerate(buttons):
        text = btn.inner_text() if btn.is_visible() else "[hidden]"
        print(f"  [{i}] {text}")

    links = page.locator('a[href]').all()
    print(f"\nFound {len(links)} links:")
    for link in links[:5]:
        print(f"  - {link.inner_text().strip()} -> {link.get_attribute('href')}")

    inputs = page.locator('input, textarea, select').all()
    print(f"\nFound {len(inputs)} input fields:")
    for inp in inputs:
        name = inp.get_attribute('name') or inp.get_attribute('id') or "[unnamed]"
        print(f"  - {name} ({inp.get_attribute('type') or 'text'})")

    page.screenshot(path='/tmp/page_discovery.png', full_page=True)
    print("\nScreenshot saved to /tmp/page_discovery.png")
    browser.close()
