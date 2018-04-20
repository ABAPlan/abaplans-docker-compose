# docker-compose.yml pour le projet ABAPlans

Ce fichier orchestre la manière dont les images docker du projet ABAPlans doivent être démarrées en service.

## Services

Le projet ABAPlans actuel se compose des services suivants:

- `reverse-proxy` pour permettre de servir plusieurs noms de domaine différents depuis la même machine Docker
- `frontend-demo` qui sert les fichiers statiques de la version de démonstration du frontend
- `frontend-prod` qui sert les fichiers statiques de la version publique du frontend

### reverse-proxy

Image: <https://hub.docker.com/r/jwilder/nginx-proxy/>

Utilisé pour servir plusieurs noms de domaines différents sur les mêmes ports (80 & 445 - HTTP & HTTPS) de la machine Docker.

Documentation plus complète ici: <http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/>.

Comme indiqué dans la documentation, cette image utilise l'API Docker pour identifier les autres containers de la machine et faire office de proxy.
C'est donc à ce service qu'on connecte les ports de la machine Docker.

```docker-compose.yml
ports:
  - "80:80"
  - "443:443"
```

Chaque service shouaitant recevoir une partie du trafic en fonction du nom de domaine doit être lancé avec une variable d'environnement comme suivant: `VIRTUAL_HOST=subdomain.youdomain.com`.

Le service doit également avoir accès aux éventuels certificats des domaines à servir, qu'il faut placer dans le dossier `/etc/nginx/certs`.
Pour donner accès à l'API Docker il faut fournir un socket au service, ce qui avec le dossier des certificats donne le résultat suivant:

```docker-compose.yml
volumes:
  - /dossier/qui/contient/les/certificats:/etc/nginx/certs:ro
  - /var/run/docker.sock:/tmp/docker.sock:ro
```

### frontend-demo & frontend-prod

Image: Construite sur le serveur à partir du repository suivant: <https://github.com/ABAPlan/abaplans-frontend-docker-image>

L'image est construite à partir du même `Dockerfile` que le service `frontend-demo`.

À la construction de l'image, les fichiers statique du frontend et les certificats de démo sont fournis à la place de ceux de production.

Les variables d'environnement suivantes sont fournies pour permettre au service `reverse-proxy` de faire passerelle correctement:

```docker-compose.yml
environment:
  - VIRTUAL_HOST=<nom de domaine à servir>
  - VIRTUAL_PORT=443
  - VIRTUAL_PROTO=https
```