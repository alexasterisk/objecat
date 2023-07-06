<h1 align="center">Objecat</h1>
<div align="center">
	Yet Another Way To Create Instances
</div>
<div>&nbsp;</div>

Objecat is a very simple library coming with only two functions and one variable. It is used to create Instances in a less verbose way. To put it simply, making an Instance on Roblox and setting its properties is ugly. Objecat makes it less ugly.

Objecat uses standard naming conventions when it comes to properties and methods. Property names and method names are in `camelCase`. This currently does not apply to *after* it is created, only on creation, this may be changed in a future release.

## Installation
Objecat can be installed in these ways:

- Using [Wally](https://github.com/UpliftGames/wally) (recommended for [Rojo](https://rojo.space/) projects)
- Using [NPM](https://www.npmjs.com/package/@rbxts/objecat) (recommended for [roblox-ts](https://roblox-ts.com/) projects)
- Or The [Roblox Model]()

### Installation Using Wally
To install using Wally, you just need to add the following to your `wally.toml` file:

```toml
[dependencies]
Objecat = "alexinite/objecat@1.0.0"
```

Then run `wally install` in your terminal.

### Installation Using NPM
If you're using roblox-ts, this will be the preferred way to download it.

```bash
npm install @rbxts/objecat
```

## Usage
Objecat has three main exports: `create()`, `event()`, and `children`. These are all documented below.

### `create(className: string, properties?: table): Instance`
`create<T extends keyof CreatableInstances>(className: T, properties?: ObjecatWritableProperties<Instances[T]>): Instances[T]`

`create()` is the main function of Objecat. Used for creating instances, in general this should be the only top-level function you use from Objecat, the other two are used to define properties and events when creating instances.

```lua
local Objecat = require(path.to.objecat.package)
local create = Objecat.create

local part = create("Part", {
	anchored = true,
	position = Vector3.new(0, 5, 0),
	parent = workspace
})

part.Anchored = false -- This may be changed in the future to be lowercase
```

```ts
import { create } from "@rbxts/objecat";

const part = create("Part", {
	anchored: true,
	position: new Vector3(0, 5, 0),
	parent: game.Workspace,
});

part.Anchored = false;
```

### `event(str: string): string`
`event<K extends string>(str: K): \`__event_${K}__\``

`event()` just takes a string and returns a string to be used as a symbol for an event. This is used to define events when creating instances. When destroying an Instance created by Objecat, any event will be automatically disconnected for you.

```lua
local event = Objecat.event

local part = create("Part", {
	[event "touched"] = function (otherPart)
		print("Touched by " .. otherPart.Name .. "!")
	end
})

-- This may be changed in the future to support event()
part.ChildAdded:Connect(function (child)
	print("Child added!")
end)
```

```ts
import { create, event } from "@rbxts/objecat";

const part = create("Part", {
	[event("touched")] = (otherPart: BasePart) => {
		print(`Touched by ${otherPart.Name}!`);
	},
});

part.ChildAdded.Connect((child) => {
	print("Child added!");
});
```

### `children: string`
`children: "__children__"`

`children` is a string that just refers to a symbol for adding children to an Instance being created with Objecat. When destroying the parent Instance, all children will be automatically destroyed for you, including their events.

Children can either be an `Array` (or table) of Instances, or a single Instance.

```lua
local children = Objecat.children

local part = create("Part", {
	[children] = {
		create("PointLight")
	}
})
```

```ts
import { create, children } from "@rbxts/objecat";

const part = create("Part", {
	[children]: [
		create("PointLight")
	],
});
```

## Current Roadmap
- [ ] Make the `create()` method behave more like [Elttob](https://github.com/Elttob)'s `New()` method for [Fusion](https://github.com/Elttob/Fusion/).
- [ ] Maybe add support for after a Instance is created via `create()` to be able to define properties, children, and events as if you were still in the `create()` function.
- [ ] Add `self` to events created with `event()` so you can access the Instance that the event is attached to.
- [ ] Somehow make `event()` know what events can and can't be created?