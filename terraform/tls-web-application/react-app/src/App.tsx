import dnsimpleLogo from './assets/dnsimple.svg'
import terraformLogo from './assets/terraform.svg'
import './App.css'

function App() {

  return (
    <>
      <div>
        <a href="https://dnsimple.com" target="_blank">
          <img src={dnsimpleLogo} className="logo" alt="DNSimple logo" />
        </a>
        <a href="https://www.terraform.io/" target="_blank">
          <img src={terraformLogo} className="logo" alt="Terraform logo" />
        </a>
      </div>
      <h1>DNSimple TLS & Terraform</h1>
    </>
  )
}

export default App
