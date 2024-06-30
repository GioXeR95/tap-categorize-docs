#!/bin/sh

# Wait for Kibana to be up and running
#while ! nc -z kibana 5601; do sleep 1; done

# Import the dashboard
curl -X POST "kibana:5601/api/saved_objects/_import?overwrite=true" \
-H "kbn-xsrf: true" \
--form file=@/usr/share/kibana/config/dashboard/export.ndjson