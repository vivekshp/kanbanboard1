import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import ProtectedRoutes from './components/ProtectedRoutes';
import Home from './pages/home/Home';
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';
import AppLayout from './layouts/AppLayout';

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route element={<AppLayout><Login /></AppLayout>} path="/login" />
          <Route element={<AppLayout><Register /></AppLayout>} path="/register" />
          <Route element={<AppLayout><ProtectedRoutes /></AppLayout>}>
            <Route path="/" element={<Home />} />
          </Route>
          <Route path="*" element={<AppLayout><Login /></AppLayout>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}