import requests
import json

# ACE HTTP endpoint
# ⚠️ Update this URL to match your ACE flow endpoint
# Example: http://localhost:7600/MyApp/convertXML
ACE_FLOW_URL = "http://localhost:7600/MyApp/convertXML"

def test_xml_to_json_conversion():
    # Read input XML and expected JSON output
    with open("tests/testdata/input.xml", "r") as f:
        xml_input = f.read()
    with open("tests/testdata/expected_output.json", "r") as f:
        expected_output = json.load(f)

    # Send XML to ACE flow
    headers = {"Content-Type": "application/xml"}
    response = requests.post(ACE_FLOW_URL, data=xml_input, headers=headers)

    # Basic response checks
    assert response.status_code == 200, f"Expected 200 but got {response.status_code}"

    # Try parsing JSON response
    try:
        actual_output = response.json()
    except Exception as e:
        raise AssertionError(f"Response is not valid JSON: {response.text}")

    # Validate key-value match
    assert actual_output == expected_output, (
        f"Expected {expected_output}, but got {actual_output}"
    )

    print("✅ XML-to-JSON flow validation passed!")
