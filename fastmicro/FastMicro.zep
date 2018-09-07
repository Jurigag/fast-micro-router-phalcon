namespace Fastmicro;

use Phalcon\Mvc\Micro;

class FastMicro extends Micro
{
    protected handlersIds = [];

    protected removeExtraSlashes = true;

    protected _router;

    public function map(routePattern, handler)
    {
        var router, route, id;
        let router = this->getRouter();

        if (!router->isBuildFromCache()) {
            let route = router->add(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[routePattern] = id;
        } else {
            let id = this->handlersIds[routePattern];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function get(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern . "_GET";

        if !router->isBuildFromCache() {
            let route = router->addGet(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = id;
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function post(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_POST";

        if !router->isBuildFromCache() {
            let route = router->addPost(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = id;
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function put(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_PUT";

        if (!router->isBuildFromCache()) {
            let route = router->addPut(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = route->getRouteId();
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function patch(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_PATCH";

        if (!router->isBuildFromCache()) {
            let route = router->addPatch(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = route->getRouteId();
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function head(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_HEAD";

        if (!router->isBuildFromCache()) {
            let route = router->addHead(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = id;
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function delete(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_DELETE";

        if (!router->isBuildFromCache()) {
            let route = router->addDelete(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = route->getRouteId();
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function handle(uri = null)
    {
        var result, cacheService, router;

        let router = this->_router;

        let result = parent::handle(uri);
        if (router->isCache() && !router->isBuildFromCache()) {
            let cacheService = this->_dependencyInjector->get(router->getCacheSimpleService());
            cacheService->save("PHFM_handlersIds", this->handlersIds);
        }

        return result;
    }

    public function options(routePattern, handler)
    {
        var router, key, route, id;

        let router = this->getRouter();

        let key = routePattern."_OPTIONS";

        if (!router->isBuildFromCache()) {
            let route = router->addDelete(routePattern);
            let id = route->getRouteId();
            let this->handlersIds[key] = id;
        } else {
            let id = this->handlersIds[key];
            let route = router->getRouteById(id);
        }

        let this->_handlers[id] = handler;

        return route;
    }

    public function getRouter()
    {
        var router, cacheService;

        let router = this->_router;

        if (!router) {
            let router = this->getSharedService("router");

            /**
             * Phalcon clears here routes for no reason, since we implemented caching we don't do it
             */

            /**
             * Make remove extra slashes finally as property
             */
            router->removeExtraSlashes(this->removeExtraSlashes);

            let this->_router = router;
            if (router->isBuildFromCache()) {
                /** @var BackendInterface $cacheService */
                let cacheService = this->_dependencyInjector->get(router->getCacheSimpleService());
                let this->handlersIds = cacheService->get("PHFM_handlersIds");
            }
        }

        return router;
    }

    public function isRemoveExtraSlashes()
    {
        return this->removeExtraSlashes;
    }

    public function setRemoveExtraSlashes(removeExtraSlashes)
    {
        let this->removeExtraSlashes = removeExtraSlashes;

        return this;
    }
}
