import os
import requests
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_PATH = os.path.join(BASE_DIR, "testdata", "input.xml")
EXPECTED_PATH = os.path.join(BASE_DIR, "testdata", "expected_output.json")

ACE_FLOW_URL = "http://localhost:7801/first"

def test_xml_to_json_conversion():
    with open(INPUT_PATH, "r") as f:
        xml_input = f.read()
    with open(EXPECTED_PATH, "r") as f:
        expected_output = json.load(f)

    headers = {"Content-Type": "application/xml"}
    response = requests.post(ACE_FLOW_URL, data=xml_input, headers=headers)

    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    try:
        actual_output = response.json()
    except Exception:
        raise AssertionError(f"Response is not valid JSON: {response.text}")

    assert actual_output == expected_output, (
        f"Expected {expected_output}, but got {actual_output}"
    )

    print("✅ XML-to-JSON flow validation passed!")
