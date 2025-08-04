# linux_cli Docker image

## Build image

```
docker build -t linux_cli .
```

## Spuštění kontejneru s interaktivním skriptem

Spuštění celého skriptu:

```
docker run --rm linux_cli
```

Pro výpis pouze IP adres v kontejneru:

```
docker run --rm linux_cli -a
```

Pro výpis informací o procesech v kontejneru:

```
docker run --rm linux_cli processinfo
```

Nebo pro výpis informací o uživateli v kontejneru:

```
docker run --rm linux_cli -i
```

Můžete použít všechny podporované přepínače skriptu `linux_cli.sh`.

## Poznámky
- Image je založen na Ubuntu a obsahuje pouze základní utility (iproute2, procps, coreutils, bash).
- Není instalován Docker uvnitř kontejneru.
- Skript je spouštěn jako ENTRYPOINT, takže lze přímo předávat parametry.
Jmenuji se Adam Pastrňák a je mi 26 let.
Od kurzu očekávám, že získám zkušenosti a znalosti Linuxu a dalších aplikací, které mi pomohou uplatnit se na juniorské/medior pozici.
=======
# beeit_devops_2025_leto

