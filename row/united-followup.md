# ROW Contact Info Update — Pending Followups

These items were intentionally skipped from the March 2026 contact info reformatting update because they were not included in the respective country's email.docx brief. They should be reviewed and updated in a future pass.

## be/nl — Belgian Dutch (policy question section)

**File:** `row/be/nl/policy-confirmation.html`

**Current text (line ~153):**
```
Heeft u een vraag, belt u ons dan op {{CustomerServicesContactNumber}} tussen {{CustomerServiceOperatingHours}} OF stuur een e-mail naar {{CustomerServicesEmailAddress}} onder vermelding van uw Polisnummer.
```

**Expected new format** (matching be/en and be/fr pattern, translated to Dutch):
```
Als u vragen heeft over uw verzekering, kunt u contact met ons opnemen via:
- Website: {{CustomerServicesURL}}
- E-mail: {{CustomerServicesEmailAddress}}
- Telefoon: {{CustomerServicesContactNumber}}

Openingstijden: {{CustomerServiceOperatingHoursLocal}}
```
Keep existing post sentence ("Wilt u uw verzekeringsdocumenten per post ontvangen...") unchanged.

**Note:** Also check whether the be/nl emergency section needs the same WTPEmail/TGEmail update applied to be/en and be/fr.

---

## it/it — Italian (policy question section)

**File:** `row/it/it/policy-confirmation.html`

**Current text (line ~311):**
```
In caso di domande e /o informazioni sulla sua polizza, la preghiamo di contattare il numero {{CustomerServicesContactNumber}}, {{CustomerServiceOperatingHours}} o di inviare una e-mail al seguente indirizzo {{CustomerServicesEmailAddress}} indicando il numero di polizza {{policyDetail-policyNumber}}.
```

**Expected new format** (matching it/en pattern, translated to Italian):
```
Se ha delle domande sulla sua assicurazione, può contattarci a:
- Sito web: {{CustomerServicesURL}}
- E-mail: {{CustomerServicesEmailAddress}}
- Telefono: {{CustomerServicesContactNumber}}

Orari di apertura: {{CustomerServiceOperatingHoursLocal}}
```
Keep existing post sentence ("Ha il diritto di ricevere copia in formato cartaceo...") unchanged.
