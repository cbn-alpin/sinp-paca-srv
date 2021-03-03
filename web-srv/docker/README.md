# Docker

## Synchronisation serveur

Pour transférer uniquement un dossier contenant les fichiers Docker d'un domaine
sur le serveur, utiliser `rsync` en testant avec l'option `--dry-run` (à supprimer quand tout est ok):

```
# Exemple pour cms.silene.eu
cd cms.silene.eu
rsync -av --copy-unsafe-links ./ admin@web-paca-sinp:~/docker/cms.silene.eu/ --dry-run
```
