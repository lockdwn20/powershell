# TheHive 5 Case Template Export

## Overview
This archive contains a one-time export of all case templates from **TheHive 5**.  
The export was performed via the Query API using the `listCaseTemplate` query.

## Export Details
- **Date of Export:** YYYY-MM-DD HH:MM (UTC/PDT)
- **Environment:** <hostname or environment name>
- **API Endpoint:** `/api/v1/query`
- **Query Used:**
  ```json
  {
    "query": [
      { "_name": "listCaseTemplate" }
    ]
  }
