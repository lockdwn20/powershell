# {{displayName}}
---
**Owner:** {{_createdBy}}  
**Last Updated:** {{_updatedAt}}

**Description:** {{description}}

- Severity: {{severity}} - {{severityLabel}}
- TLP: {{tlp}} - {{tlpLabel}}
- PAP: {{pap}} - {{papLabel}}

## TheHive Tags: 
{{#each tags}} - {{tags}}
{{/each}}

{{#each tasks}}
## Task {{order}}: {{title}}
- Description: {{description}}
{{/each}}

## Notes
{{#if extraData}}
{{extraData}}
{{/if}}