import axios from 'axios'
import { accountService } from './account.service'

const baseUrl = import.meta.env.VITE_API_BASE_URL

// Paramétrage de base d'axios
// const Axios = axios.create({
//     baseURL: 'http://mono.testeur.clic-boum-paf.com:12000'
// })
const Axios = axios.create({
    baseURL: baseUrl
})


// Intercepteur pour la mise en place du token dans la requête
Axios.interceptors.request.use(request => {

    if(accountService.isLogged()){
        request.headers.Authorization = 'Bearer '+accountService.getToken()
    }

    return request
})

// Intercepteur de réponse API pour vérification de la session
Axios.interceptors.response.use(response => {
    return response
}, error => {
    if(error.response.status === 401){
        accountService.logout()
        
        const actual = window.location.href
        if(!actual.endsWith('/auth/login')){
            window.location = '/auth/login'
        }
    }else{
        return Promise.reject(error)
    }
})

export default Axios