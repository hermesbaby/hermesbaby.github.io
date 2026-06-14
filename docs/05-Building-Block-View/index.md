(sec_building_block_view)=

# Building Block View

The building block view shows the static decomposition of the system into building blocks (modules, components, subsystems, classes, interfaces, packages, libraries, frameworks, layers, partitions, tiers, functions, macros, operations, data structures, …) as well as their dependencies (relationships, associations, ...)

This view is mandatory for every architecture documentation. In analogy to a house this is the *floor plan*.

## Container Level

<!--

Note: The container view, where containers are displayed as black boxes and internal components
are hidden, can usually be created quite easily by first deriving it from the component
diagram created. This approach made it easier to identify and assign the components of the (known) system.

This container view serves as an intermediate step between the context and component level to give readers a better
overview of the main components of the system without immediately having to deal with the details of individual components.

-->

```{drawio-figure} _figures/container.drawio
Containers of the System SomeSystem
```

```{todo}
Add description of the containers and their interactions. The text should mention at least once:

- SomeSystem
- SomePerson
- SomeExternalPerson
- SomeContainer
- SomeOtherContainer
- Some External System
```

## Component Level

```{drawio-figure} _figures/component.drawio
Components of the System SomeSystem
```

```{todo}
Add description of the components and their interactions. The text should mention at least once:

- SomePerson
- SomeExternalPerson
- Some External System
- SomeSystem
- Component_A
- Component_B
- Component_C
- Component_D
- Component_E
```

```{todo}
Add {ref}`sec_building_block_view`, see [arc42-guideline](https://docs.arc42.org/section-5/)
```
