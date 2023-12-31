# Further details of screenshot API
# https://miyakogi.github.io/pyppeteer/reference.html#pyppeteer.page.Page.screenshot

import asyncio
import pytest
from pyppeteer.errors import PageError
from urllib.parse import quote
import os
import sys
from os import environ
from pyppeteer import connect, launch

exec_platform = os.getenv('EXEC_PLATFORM')

timeOut = 60000

test_url = 'https://ecommerce-playground.lambdatest.io/index.php?route=product/category&path=30'
loc_product_1 = "#mz-product-grid-image-43-212408 > div > div.carousel-item.active > img"
loc_final_product = "#image-gallery-216811 > div.image-thumb.d-flex > a > img"
target_url = "https://ecommerce-playground.lambdatest.io/index.php?route=product/product&path=25_30&product_id=43"

@pytest.mark.asyncio
@pytest.mark.order(1)
async def test_screenshot(page):
    # The time out can be set using the setDefaultNavigationTimeout
    # It is primarily used for overriding the default page timeout of 30 seconds
    page.setDefaultNavigationTimeout(timeOut)
    await page.goto(test_url,
        {'waitUntil': 'networkidle2', 'timeout': timeOut})

    await asyncio.sleep(1)

    # Wait for the element to be present in the DOM
    elem_prod_link = await page.waitForSelector(loc_product_1, {'visible': True})

    await asyncio.sleep(2)

    await asyncio.gather(
        elem_prod_link.click(),
        page.waitForNavigation()
    )

    # Assert if required, since the test is a simple one; we leave as is :D
    current_url = page.url
    print('Current URL is: ' + current_url)

    try:
        assert current_url == target_url
        print("Test Success: Product checkout successful")
    except PageError as e:
        print("Test Failure: Could not checkout Product")
        print("Error Code" + str(e))

    await asyncio.sleep(2)

    # Wait for the element to be present in the DOM
    await page.waitForSelector(loc_final_product)
    elem_prod_img = await page.querySelector(loc_final_product)

    # Further information on boundingBox
    # https://miyakogi.github.io/pyppeteer/reference.html#pyppeteer.element_handle.ElementHandle.boundingBox
    bounding_box = await elem_prod_img.boundingBox()

    # Take a screenshot of the element
    if bounding_box:
        await elem_prod_img.screenshot({'path': 'product-screenshot.png', 'clip': bounding_box})

    await asyncio.sleep(1)

    # Take a screenshot of the entire page
    await page.screenshot({'path': 'page-screenshot.png', 'fullPage': False})

    # Take a screenshot of the scrollable page
    await page.screenshot({'path': 'scrollable-page-screenshot.png', 'fullPage': True})
