# Exceptions

One row per rule this repository cannot meet yet. The reason and the revisit date
are required. The shared `standard` job reads this file.

| Rule | Reason | Revisit |
| --- | --- | --- |
| `community/.aislop/config.yml` | The aislop dependency audit is off because the transitive `http-cache-semantics` 4.2.0 carries CVE-2026-93748 with no fixed version, and the Trivy scan is the dependency gate. The divergence is documented in the file. | 2027-02-28 |
