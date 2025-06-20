# CI/CD Workflow with GitHub Actions, SonarCloud, GHCR and GitOps

Este repositorio implementa un flujo de trabajo moderno para integrar desarrollo, análisis de calidad, construcción de imágenes y despliegue automatizado en Kubernetes utilizando GitHub Actions y GitOps.

---

## 🧩 Flujo de trabajo general

1. El desarrollador crea una rama `feature/*` o `fix/*` y sube su código a GitHub.
2. Se genera un **Pull Request**.
3. En el Pull Request se ejecuta análisis de código estático y pruebas (por ejemplo, SonarCloud).
4. Al hacer merge a `main`:
   - Se ejecuta un pipeline automático.
   - Se construye y publica una imagen de contenedor en **GHCR**.
   - Se generan los manifiestos de Kubernetes basados en la imagen.
   - Se hace push de estos manifiestos a un repositorio separado de GitOps.

---

## 🔁 Diagrama del flujo

> Puedes reemplazar esta imagen con tu versión final exportada del diagrama:

```mermaid
flowchart TD
    A[Developer] --> B[Feature / Fix Branch]
    B --> C[Pull Request]
    C --> D[SonarCloud Analysis]
    C --> E[Merge to Main]
    E --> F[Automated Pipeline]
    F --> G[Unit Tests / Scan]
    G --> H[Build & Push Image]
    H --> I[Generate K8s Manifests]
    I --> J[Push to GitOps Repo]
