# Fast router and micro for Phalcon

Project to implement router for phalcon with better performance like FastRoute/Router from Symfony 4.1

Compile it with zephir and change your router/micro to provided by our extension.

Best results with cache enabled and `Phalcon\Cache\Frontend\Igbinary` with `Phalcon\Cache\Backend\File` for `cacheSimpleService` and `Phalcon\Cache\Frontend\Data` with `Phalcon\Cache\Backend\File` for `cacheObjectService`

## Register router in di

First you need to register router in di:

```php
$di->set(
    'router',
    function () {
        $router = new \Fastmicro\FastRouter(false);
        $router->useCache(true, 'router', 'cache', 'igbinaryCache');
        
        return $router;
    }
);
```

Method `Fastmicro\FastRouter::useCache` accepts 4 arguments, boolean as indiciator if to use cache, key under which store caching data(though we still prefix it) and service names for `Phalcon\Mvc\Router\Route` objects and arrays/strings.

## Usage with Phalcon\Mvc\Application

To use this efficient you need to update your code, i.e how you add routes:

#### Usage for router->add()

For all `router->add()` calls you need to put code into callback, for example let's assume this code:

```php
$router->add('/test', ['action' => 'test', 'controller' => 'test']);
$router->add('/test2', ['action' => 'test2', 'controller' => 'test']);
```

You need to change your code into:

```php
$router->addCallbackRoutes(function ($router) {
    $router->add('/test', ['action' => 'test', 'controller' => 'test']);
    $router->add('/test2', ['action' => 'test2', 'controller' => 'test']);
});
```

This will cause that this callback will be called only once when building cache.

#### Usage for Phalcon\Mvc\Router\Group

This is easiest way to implement caching, instead of `$router->mount(new Group())` just do `$router->mountGroupClassName(Group::class)`

Group objects will be created only once and routes from them will be added to router using methods from our router.

## Usage with Phalcon\Mvc\Micro

#### Non-collection handlers

You need to use our provided micro and set our router in di, nothing more to do currently, in future we might add [super_closure](https://github.com/jeremeamia/super_closure) as way to cache closuers but it will require tests if it's actually worth it. Currently with our micro and router the boost is less significant than in other cases since direct handler storing which we can't cache.

#### Collection handlers

Soon

## Serialization of 'Closure' is not allowed

If you have this error it means that you use for example `$router->add()->beforeMatch()`. Php can't serialize closuers so you need to handle it differently. I suggest you set names for your routes and use added event `router:afterBuild` to which you can attach your function where you will get routes by names for which you want set `beforeMatch`. `router:afterBuild` is fired after router is build from cache or when there is no cache, then it's build on first handle. Build from cache happens as soon router is accessed as a service.

Other solution is to implemenet Phalcon Frontend cache with [super_closure](https://github.com/jeremeamia/super_closure) but i don't recommend it.

## TODO

- [x] Provide router with grouping regexpes
- [x] Provide router with ability to cache routes
- [x] Provide micro which will work with new router
- [ ] Group regexpes by common prefix for even faster matching and shorter regexpes
- [ ] Create array of regexpes in case we might get too long regexpes
- [ ] Add readme on collection handlers
- [ ] Write tests
- [ ] Handle routes with diffrent regexp which can be matched by same url but have diffrent method/hostname
- [ ] Change namespace and class names if needed to better
