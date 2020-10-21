# xq on the Web

## Build

```
docker build -t webxq .
```

## Run

```
docker run --rm -p 8000:8080 webxq
```

## Test

```
curl --data-binary @test.xml localhost:8000
```
