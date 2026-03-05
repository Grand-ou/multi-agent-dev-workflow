# Web Application Testing Guide

Use Playwright to test and verify web applications during and after development.

## Quick Reference

### Decision Tree
```
Task → Is it static HTML?
  ├─ Yes → Read HTML file → identify selectors → write Playwright script
  └─ No (dynamic webapp) → Is the server running?
      ├─ No → Use with_server.py to manage server lifecycle
      └─ Yes → Reconnaissance-then-action:
          1. Navigate + wait for networkidle
          2. Screenshot or inspect DOM
          3. Identify selectors from rendered state
          4. Execute actions with discovered selectors
```

### Common Pitfall
❌ Don't inspect DOM before waiting for `networkidle` on dynamic apps
✅ Do wait for `page.wait_for_load_state('networkidle')` first

---

## Using with_server.py

Manages server lifecycle automatically. Run `--help` first.

**Single server:**
```bash
python scripts/with_server.py --server "npm run dev" --port 5173 -- python your_test.py
```

**Multiple servers (backend + frontend):**
```bash
python scripts/with_server.py \
  --server "cd backend && python server.py" --port 3000 \
  --server "cd frontend && npm run dev" --port 5173 \
  -- python your_test.py
```

---

## Reconnaissance-Then-Action Pattern

Always inspect before acting on dynamic pages:

### Step 1: Inspect Rendered DOM
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')  # CRITICAL

    # Take screenshot for visual reference
    page.screenshot(path='/tmp/inspect.png', full_page=True)

    # Discover elements
    buttons = page.locator('button').all()
    print(f"Found {len(buttons)} buttons:")
    for i, btn in enumerate(buttons):
        text = btn.inner_text() if btn.is_visible() else "[hidden]"
        print(f"  [{i}] {text}")

    links = page.locator('a[href]').all()
    inputs = page.locator('input, textarea, select').all()

    browser.close()
```

### Step 2: Identify Selectors
From inspection results, choose selectors:
- `text=Button Text` — by visible text
- `role=button[name="Submit"]` — by ARIA role
- `#element-id` — by ID
- `.class-name` — by CSS class

### Step 3: Execute Actions
```python
# Click, fill, submit
page.click('text=Login')
page.fill('#username', 'testuser')
page.fill('#password', 'testpass')
page.click('button[type="submit"]')
page.wait_for_selector('.dashboard')  # Wait for result
```

---

## Console Log Capture

Useful for debugging runtime errors:

```python
console_logs = []

def handle_console(msg):
    console_logs.append(f"[{msg.type}] {msg.text}")
    print(f"Console: [{msg.type}] {msg.text}")

page.on("console", handle_console)
page.goto('http://localhost:5173')
page.wait_for_load_state('networkidle')

# ... interact with page ...

# Save logs
with open('/tmp/console.log', 'w') as f:
    f.write('\n'.join(console_logs))
```

---

## Static HTML Testing

For static files, use `file://` URLs:

```python
import os
html_path = os.path.abspath('dist/index.html')

page.goto(f'file://{html_path}')
page.screenshot(path='/tmp/static_page.png', full_page=True)
page.click('text=Click Me')
page.fill('#name', 'Test User')
```

---

## Integration with Multi-Agent Workflow

### During Phase 2 (Sub-Agent Development)

Each Sub-Agent should write tests alongside features:

```python
# test_auth.py — Sub-Agent writes this with the auth feature
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')

    # Test: login button exists
    assert page.locator('text=Login with Google').is_visible()

    # Test: protected route redirects
    page.goto('http://localhost:5173/dashboard')
    assert page.url.endswith('/login')

    browser.close()
    print("✅ Auth tests passed")
```

### During Phase 4 (Integration Testing)

Run all feature tests together:

```bash
# Start all servers + run integration tests
python scripts/with_server.py \
  --server "cd backend && node index.js" --port 3000 \
  --server "cd frontend && npm run dev" --port 5173 \
  -- python tests/integration_test.py
```

Integration test pattern:
```python
# tests/integration_test.py
from playwright.sync_api import sync_playwright

def test_full_workflow():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto('http://localhost:5173')
        page.wait_for_load_state('networkidle')

        # 1. Verify homepage loads
        assert page.title() != ""

        # 2. Test navigation between features
        page.click('text=Chat')
        page.wait_for_selector('.chat-input')

        # 3. Test cross-feature integration
        page.fill('.chat-input', 'Hello')
        page.click('button:text("Send")')
        page.wait_for_selector('.message-bubble')

        # 4. Screenshot final state
        page.screenshot(path='/tmp/integration_test.png')
        browser.close()

    print("✅ Integration tests passed")

test_full_workflow()
```

---

## Best Practices

- **Always use `headless=True`** for automated testing
- **Always wait for `networkidle`** before inspecting dynamic pages
- **Use descriptive selectors**: `text=`, `role=`, CSS selectors, or IDs
- **Add timeouts**: `page.wait_for_selector()` or `page.wait_for_timeout()`
- **Close browser** when done to free resources
- **Save screenshots** at key points for debugging
