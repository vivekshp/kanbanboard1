import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { login as apiLogin } from '../../lib/api';
import './login.css';

export default function Login() {
  const { setUser } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: '', password: '' });
  const [err, setErr] = useState('');

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr('');
    try {
      const res = await apiLogin({ email: form.email, password: form.password });
      setUser(res.user);
      navigate('/');
    } catch (error) {
        if (error.response?.data?.errors) {
          setErr(error.response.data.errors.join(", "));
        } else {
          setErr("Login failed");
        }
    }
  };

  return (
    <div className="auth-wrap">
      <div className="auth-card">
        <h2 className="auth-title">Welcome back</h2>
        <form className="auth-form" onSubmit={onSubmit}>
          <label className="auth-label">Email</label>
          <input className="auth-input" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} />

          <label className="auth-label">Password</label>
          <input className="auth-input" type="password" value={form.password} onChange={e => setForm({ ...form, password: e.target.value })} />

          {err && <p className="auth-error">{err}</p>}
          <button className="auth-button" type="submit">Login</button>
        </form>
        <p className="auth-meta">No account? <Link to="/register">Create one</Link></p>
      </div>
    </div>
  );
}