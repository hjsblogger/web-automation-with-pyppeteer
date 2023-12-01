# Define variables
PYTHON := python3
PYTEST := pytest
PIP := pip3
PROJECT_NAME := web scraping using Python

.PHONY: install
install:
	$(PIP) install -r requirements.txt
	@echo "Set env vars LT_USERNAME & LT_ACCESS_KEY"
    # Procure Username and AccessKey from https://accounts.lambdatest.com/security
    export LT_USERNAME=himansh
    export LT_ACCESS_KEY=Ia1MiqNfci

.PHONY: install
poetry-install:
	poetry install

.PHONY: test
test:
    export NODE_ENV = test

.PHONY: test
pyunit-pyppeteer:
	- echo $(EXEC_PLATFORM)
	- $(PYTHON) tests/pyunit-pyppeteer/test_pyunit_pyppeteer.py

.PHONY: test
pytest-pyppeteer:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s -n 2 tests/pytest-pyppeteer/test_pytest_pyppeteer_1.py \
	tests/pytest-pyppeteer/test_pytest_pyppeteer_2.py

.PHONY: test
pyppeteer-button-click:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/button-click/test_page_class_click.py

.PHONY: test
pyppeteer-activate-tab:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/active-tab/test_page_class_bringToFront.py

###### Testing Custom Environment - https://miyakogi.github.io/pyppeteer/reference.html#environment-variables
# Available versions: 113, 121, and default 
.PHONY: test
pyppeteer-custom-chromium-version:
	- echo $(EXEC_PLATFORM)
	- echo 'Browser Version:' $(CHROMIUM_VERSION)
	- $(PYTEST) --verbose --capture=no -s tests/custom-configuration/test_launcher_exe_path.py

###### Testing Headless - https://miyakogi.github.io/pyppeteer/reference.html#launcher
# Available values: headless and non-headless
.PHONY: test
pyppeteer-custom-browser-mode:
	- echo $(EXEC_PLATFORM)
	- echo $(BROWSER_MODE)
	- $(PYTEST) --verbose --capture=no -s tests/custom-configuration/test_launcher_headless.py

.PHONY: test
pyppeteer-generate-pdf:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/generate-pdf/test_page_class_pdf.py

.PHONY: test
pyppeteer-generate-screenshot:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/generate-screenshots/test_page_class_screenshot.py

.PHONY: test
pyppeteer-cookies:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/handling-cookies/test_page_class_cookies.py

.PHONY: test
pyppeteer-dialog-box:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/handling-dialog-box/test_handling_dialog_box.py

.PHONY: test
pyppeteer-iframe:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/handling-iframe/test_page_class_iframe.py

# Like Puppeteer, Navigation operations mentioned below only work in Headless mode
# goBack: https://miyakogi.github.io/pyppeteer/reference.html#pyppeteer.page.Page.goBack
# goForward: https://miyakogi.github.io/pyppeteer/reference.html#pyppeteer.page.Page.goForward

# Bug Link
# https://github.com/puppeteer/puppeteer/issues/7739
# https://stackoverflow.com/questions/65540674/how-to-error-check-pyppeteer-page-goback

.PHONY: test
pyppeteer-navigate-ops:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/navigate-operations/test_page_class_navigation_ops.py

.PHONY: test
pyppeteer-request-response:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/request-response/test_page_class_req_resp.py

.PHONY: test
pyppeteer-viewport:
	- echo $(EXEC_PLATFORM)
	- echo $(BROWSER_MODE)
	- $(PYTEST) --verbose --capture=no -s tests/setting-useragent-viewports/\
	test_page_class_useragent_viewport.py::test_mod_viewport

.PHONY: test
pyppeteer-non-headless-useragent:
	- echo $(EXEC_PLATFORM)
	- echo $(BROWSER_MODE)
	- $(PYTEST) --verbose --capture=no -s tests/setting-useragent-viewports/\
	test_page_class_useragent_viewport.py::test_get_nonheadless_user_agent

.PHONY: test
pyppeteer-headless-useragent:
	- echo $(EXEC_PLATFORM)
	- echo $(BROWSER_MODE)
	- $(PYTEST) --verbose --capture=no -s tests/setting-useragent-viewports/\
	test_page_class_useragent_viewport.py::test_get_headless_user_agent

.PHONY: test
pyppeteer-dynamic-content:
	- echo $(EXEC_PLATFORM)
	- echo $(BROWSER_MODE)
	- $(PYTEST) --verbose --capture=no -s -n 4 tests/handling-dynamic-content/\
	test_page_class_lazy_loaded_content.py

.PHONY: test
pyppeteer-web-scraping:
	- echo $(EXEC_PLATFORM)
	- $(PYTEST) --verbose --capture=no -s tests/web-scraping-content/\
	test_scraping_with_pyppeteer.py

.PHONY: clean
clean:
    # This helped: https://gist.github.com/hbsdev/a17deea814bc10197285
	find . | grep -E "(__pycache__|\.pyc$$)" | xargs rm -rf
	@echo "Clean Succeded"

.PHONY: distclean
distclean: clean
	rm -rf venv

.PHONY: help
help:
	@echo ""
	@echo "install : Install project dependencies"
	@echo "clean : Clean up temp files"
	@echo "pytest-pyppeteer : Run Pyppeteer tests with Pytest framework"
	@echo "pyunit-pyppeteer : Run Pyppeteer tests with Pyunit framework"