# MobAi 2025

MobAi is a book-focused application repository with three main parts:

- `Ai/final`: a FastAPI service that powers book search, recommendation, and
  evaluation workflows.
- `FrontEnd/app`: a Flutter application that consumes the product and AI
  services.
- `BackEnd`: backend notes and supporting documentation for server-side work.

The repository is organized around a book catalog experience, combining semantic
search, recommendation logic, and mobile UI work.

## Repository Structure

```text
MobAi/
├── Ai/
│   └── final/
│       ├── app.py
│       ├── search.py
│       ├── recommend.py
│       ├── evaluator.py
│       ├── books.json
│       ├── test_results.json
│       └── .env.example
├── BackEnd/
│   └── ReadMe.md
├── FrontEnd/
│   └── app/
│       ├── lib/
│       ├── android/
│       ├── ios/
│       ├── web/
│       └── windows/
└── README.md
```

## Main Components

### AI Service

The AI service is a FastAPI app that exposes two endpoints:

- `POST /search`: runs the book search pipeline.
- `POST /recommend`: returns recommendations based on a user profile and order
  history.

The search pipeline uses:

- `SentenceTransformer` embeddings for semantic matching.
- FAISS for similarity search over the book catalog.
- LangChain and Gemini models for prompt classification and result filtering.

### Flutter Frontend

The Flutter app lives under `FrontEnd/app` and contains the main user interface,
app state, routes, models, and widgets.

### Evaluation Script

The AI folder also includes an evaluator that generates test prompts, runs them
through the search chain, and writes structured results to `test_results.json`.
