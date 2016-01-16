
this.MainLayout = React.createClass({
  render: function(){
    return (
      <div className='views'>
        <div className='view view-main'>
          <div className='pages'>
            <header>
              { this.props.header }
            </header>
            <main>
              { this.props.content }
            </main>
            <footer>
              { this.props.footer }
            </footer>
          </div>
        </div>
      </div>
    )
  }
});
