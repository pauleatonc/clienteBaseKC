import { useState, useCallback } from 'react'
import { useAuth } from '../hooks/useAuth'
import Header from '../components/Layout/Header'
import Footer from '../components/Layout/Footer'
import UserInfoCard from '../components/UserInfo/UserInfoCard'
import AuthButtons from '../components/Auth/AuthButtons'

function Home() {
  const [activeView, setActiveView] = useState(null)
  const { 
    keycloak, 
    authenticated, 
    loading, 
    error, 
    userInfo,
    handleLogin, 
    handleLogout,
  } = useAuth()

  const handleUserInfoClick = useCallback(() => {
    setActiveView('userInfo')
  }, [])

  const handlePesticidesClick = useCallback(() => {
    setActiveView('pesticides')
  }, [])

  if (loading) {
    return (
      <div className="vh-100 d-flex justify-content-center align-items-center">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Cargando...</span>
        </div>
      </div>
    )
  }

  return (
    <div className="d-flex flex-column">
      <div className="container-fluid bg-white py-4 flex-grow-1">
        <div className="row">
          <div className="col-12">
            <Header />
            
            <div className="mt-4">
              <div className="row justify-content-center">
                <div className="col-12 col-md-8">
                  {error && <p className="text-danger mb-4">{error}</p>}
                  {!error && authenticated && <p className="text-success mb-4">Sesión iniciada correctamente</p>}
                  
                  <div className="d-flex justify-content-center">
                    <AuthButtons 
                      authenticated={authenticated}
                      handleLogin={handleLogin}
                      handleLogout={handleLogout}
                      activeView={activeView}
                      onUserInfoClick={handleUserInfoClick}
                      onPesticidesClick={handlePesticidesClick}
                    />
                  </div>
                </div>
              </div>
              
              <div className="row justify-content-center mt-4">
                <div className="col-12">
                  {activeView === 'userInfo' && userInfo && (
                    <UserInfoCard userInfo={userInfo} />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  )
}

export default Home 