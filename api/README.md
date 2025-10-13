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
- 	Authentication: API key with ``` manageCaseTemplate ``` rights
- 	Output Format: Individual JSON files (one per template), plus a manifest

## Contents
 	
- 	 — raw JSON export of each case template
- 	 — list of all exported template names
- 	 — packaged archive containing the above

## Notes

- 	Filenames have been sanitized for Windows compatibility (illegal characters replaced with ).
- 	Each JSON file contains the full template object as returned by TheHive 5 Query API.
- 	This export is intended as a one-time snapshot for developer use.
Any updates or re-imports should be coordinated with the development team.
