#!/bin/bash
echo "CHECKING MULTIDRM HEALTH CHECK API"
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost/api/healthCheck)" != "200" ]]; do sleep 5; echo "Waiting for multidrm healthCheck to pass"; done