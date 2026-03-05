"""Example: Capturing console logs during browser automation."""
from playwright.sync_api import sync_playwright

console_logs = []

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={'width': 1920, 'height': 1080})

    def handle_console(msg):
        console_logs.append(f"[{msg.type}] {msg.text}")
        print(f"Console: [{msg.type}] {msg.text}")

    page.on("console", handle_console)
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')

    # Interact with page to trigger console logs
    page.click('text=Dashboard')
    page.wait_for_timeout(1000)
    browser.close()

with open('/tmp/console.log', 'w') as f:
    f.write('\n'.join(console_logs))

print(f"\nCaptured {len(console_logs)} console messages")
print("Logs saved to /tmp/console.log")
