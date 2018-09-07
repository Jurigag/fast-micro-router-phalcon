# Fast router and micro for Phalcon

Project to implement router for phalcon with better performance like FastRoute/Router from Symfony 4.1

Compile it with zephir and change your router/micro to provided by our extension.

Best results with cache enabled and `Phalcon\Cache\Frontend\Igbinary` with `Phalcon\Cache\Backend\File` for `cacheSimpleService` and `Phalcon\Cache\Frontend\Data` with `Phalcon\Cache\Backend\File` for `cacheObjectService`

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

## TODO

- [x] Provide router with grouping regexpes
- [x] Provide router with ability to cache routes
- [x] Provide micro which will work with new router
- [ ] Group regexpes by common prefix for even faster matching and shorter regexpes
- [ ] Create array of regexpes in case we might get too long regexpes
- [ ] Add readme on collection handlers
- [ ] Write tests
- [ ] Handle routes with diffrent regexp which can be matched by same url but have diffrent method/hostname
