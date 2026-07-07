🔐 Plateforme intelligente de cybersécurité — LOGISTIA

Projet M2 — Mastère ISRC (Ingénieur Systèmes Réseaux et Cybersécurité)
Centre de formation Laser — Année 2, Quatrième semestre


📌 Contexte
L'entreprise LOGISTIA exploite plusieurs entrepôts connectés assurant le stockage et la distribution de marchandises pour des clients e-commerce et industriels.
Face à l'augmentation des cyberattaques visant les chaînes logistiques, ce projet vise à concevoir et déployer une infrastructure sécurisée automatisée intégrant un SOC pédagogique, des outils IaC, un pipeline CI/CD et un modèle IA de détection d'anomalies.

👥 Équipe
MembreRôleSofianeChef de projet + Analyste cybersécuritéChaffaIngénieure IA / DataPiyasIngénieur DevOps / IaC

🏗️ Architecture
PROXMOX VE
├── srv-runner   (VLAN 50) — Terraform + Ansible + GitHub Runner
├── SRV-VM-WEB      (VLAN 20) — Nginx + App LOGISTIA (Docker)
├── SRV-VM-DB       (VLAN 20) — MariaDB
├── SRV-VM-WAZUH    (VLAN 30) — Wazuh Manager (SOC)
├── SRV-VM-GRAYLOG  (VLAN 30) — Graylog + Elasticsearch (logs)
└── SRV-VM-IA       (VLAN 40) — Isolation Forest (détection anomalies)

🛠️ Stack technique
CatégorieOutilsHyperviseurProxmox VEFirewallpfSenseIaCTerraform + AnsibleCI/CDGitHub Actions (runner self-hosted)SOCWazuh ManagerLogsGraylog + ElasticsearchIAIsolation Forest (modèle open source local)OSDebian 12 (Bookworm)

📁 Structure du dépôt
isrc-logistia/
├── terraform/          # Provisioning des VMs (Terraform)
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
├── ansible/            # Configuration des serveurs (Ansible)
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles/
├── .github/
│   └── workflows/
│       └── deploy.yml  # Pipeline CI/CD GitHub Actions
├── docs/               # Documentation architecture
└── README.md
