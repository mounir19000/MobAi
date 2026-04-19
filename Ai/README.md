# AI Service

This folder contains the AI-powered book search and recommendation service used
by MobAi.

## What It Does

- Classifies user prompts as a search request or a purchase request.
- Searches the book catalog with semantic embeddings and FAISS.
- Filters search results with a Gemini-based refinement step.
- Provides recommendation support for user and order history data.
- Includes an evaluator that generates test prompts and saves results to JSON.

## Main Files

- `final/app.py`: FastAPI application exposing the service endpoints.
- `final/search.py`: semantic search pipeline, prompt classification, and result
  filtering.
- `final/recommend.py`: recommendation logic.
- `final/evaluator.py`: automated evaluation script for the search chain.
- `final/books.json`: source catalog for embeddings and search.
- `final/test_results.json`: output from evaluator runs.
- `final/.env.example`: sample environment configuration.

## How the Search Pipeline Works

1. The prompt is classified as either a search request or a purchase request.
2. The query is embedded with `sentence-transformers/all-MiniLM-L6-v2`.
3. FAISS retrieves similar books from the catalog.
4. A Gemini model refines the result list when the query is a search.
5. The final structured response is returned to the API caller.

## Local Setup

```bash
cd Ai/final
python -m venv venv
source venv/bin/activate
cp .env.example .env
```

Add your API keys to `.env`, then install the required Python packages and run
the app:

```bash
uvicorn app:app --reload
```

## Endpoints

- `POST /search`: accepts a prompt string and returns matched books.
- `POST /recommend`: accepts user and order data and returns recommendations.

## Evaluator

Run the evaluator from `Ai/final` to generate prompt-based test results:

```bash
source venv/bin/activate
python evaluator.py
```

The evaluator writes its output to `test_results.json`.

## Environment Variables

- `GOOGLE_API_KEY`
- `LANGCHAIN_API_KEY`
- `GENAI_MODEL`
- `GENAI_MAX_TOKENS`
- `GENAI_TIMEOUT`
- `GENAI_MAX_RETRIES`

## Notes

- The project uses a prebuilt FAISS index when available.
- The search filter is written to recover gracefully from partial or malformed
  model output.
- The code is currently tuned for Gemini-backed inference and LangChain-based
  orchestration.
