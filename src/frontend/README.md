# Frontend

The frontend is a very simple single-page web application written in Elm.

It is composed of the following modules:

  * `Main` : Root module.
  * `ChooseDimension` : Handles the 'choose a variable' dialog.
  * `GetDimension` : Get the list of dimensions from the API.
  * `DisplayData` : Handles the table display.
  * `GetData` : Get the table info from the API. 

## Modules interaction

The modules that are responsible for getting values from the server
depend on the ones that display data. One could extract type definitions
from the display modules in order to break that hard dependency.

The main module depends on all others, and he passes data along from 
server-interaction modules to display modules.
It doesn't contain model or view code (except a few lines of view for error
handling).

Interactions between Main and ChooseDimension use
the [translator pattern](https://medium.com/@alex.lew/the-translator-pattern-a-model-for-child-to-parent-communication-in-elm-f4bfaa1d3f98#.x4p87na0n)
for easier future extensibility (multiple variables selection, for instance).

