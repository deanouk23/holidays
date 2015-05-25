module.exports = React.createClass
  displayName: 'DayNames'

  mixins: [
    React.addons.PureRenderMixin
  ]

  _renderNames: ->
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map (day) ->
      <div key={day} className="day"><span>{day}</span></div>

  render: () ->
    <div className="week-day-names">
      {@_renderNames()}
    </div>
