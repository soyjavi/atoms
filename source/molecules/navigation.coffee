class Atoms.Molecule.Navigation extends Atoms.BaseMolecule

  template: """
    <nav molecule-class="{{className}}" class="{{class}}">
    </nav>
  """

  bindings:
    link:   ["click"]
    button: ["click"]

  constructor: ->
    super
    console.log @
  linkClick: (event, atom) => @_trigger event, atom

  buttonClick: (event, atom) => @_trigger event, atom

  _trigger: (event, atom) ->
    event.preventDefault()
    atom.el.addClass("active").siblings().removeClass("active")
    @trigger "molecule-navigation", atom, @
