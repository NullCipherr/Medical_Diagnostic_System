FROM swipl:9.2.4

WORKDIR /app

COPY src/ /app/src/
COPY tests/ /app/tests/
COPY data/ /app/data/

CMD ["swipl", "-q", "-s", "src/cli/main.pl", "-g", "start", "-t", "halt"]
