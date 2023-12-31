import asyncio
import pytest
from pyppeteer.errors import PageError
from urllib.parse import quote
import json
import os
from os import environ
from pyppeteer import connect, launch

exec_platform = os.getenv('EXEC_PLATFORM')

# Can take values - headless and non-headless
browser_mode = os.getenv('BROWSER_MODE')

# Pytest fixture for browser setup
@pytest.fixture(scope='function')
async def browser():
    if exec_platform == 'local':
        if browser_mode == 'headless':
            browser = await launch()
        elif browser_mode == 'non-headless':   
            browser = await launch(headless = False, args=['--start-maximized']) 
    yield browser
    await asyncio.sleep(1)    
    await browser.close()

# Pytest fixture for page setup
@pytest.fixture(scope='function')
async def page(browser):
    page = await browser.newPage()
    yield page
    await page.close()

@pytest.mark.asyncio
async def test_browser_mode(page):
    await page.goto('https://www.duckduckgo.com')
    await page.setViewport({'width': 1920, 'height': 1080})

    element = await page.querySelector('[name="q"]')
    await element.click()
    await element.type('LambdaTest')
    await asyncio.gather(
        page.keyboard.press('Enter'),
        page.waitForNavigation()
    )

    page_title = await page.title()

    try:
        assert page_title == 'LambdaTest at DuckDuckGo', 'Expected page title is incorrect!'
        await page.evaluate('_ => {}', f'lambdatest_action: {json.dumps({ "action": "setTestStatus", "arguments": { "status": "passed", "remark": "Title matched" } })}')
    except PageError as e:
        await page.evaluate('_ => {}', f'lambdatest_action: {json.dumps({ "action": "setTestStatus", "arguments": { "status": "failed", "remark": str(e) } })}')