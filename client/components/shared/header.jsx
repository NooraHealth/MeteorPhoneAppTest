
this.Header = React.createClass({
  render: function(){
    return (
      <div data-page="index" className="page navbar-fixed toolbar-fixed">

        <div className="navbar">
          <div className="navbar-inner">
            <a id="logo"><img className="logo" alt="Noora Health" src="/NHlogo.png"/></a>

            { rightSideContent }
          </div>
        </div>
    )
  }
});
