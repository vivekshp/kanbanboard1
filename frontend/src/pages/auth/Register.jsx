import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { register as apiRegister } from '../../lib/api';
import './register.css';

export default function Register() {
  const { setUser } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ name: '', email: '', password: '', password_confirmation: '' });
  const [err, setErr] = useState('');

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr('');
    try {
      const res = await apiRegister(form);
      setUser(res.user);
      navigate('/');
    } catch (error) {
        if (error.response?.data?.errors) {
            setErr(error.response.data.errors.join(", "));
          } else if (error.response?.data?.error) {
            setErr(error.response.data.error);
        } else {
          setErr("Registration failed");
        }
    }
  };

  return (
    <div className="auth-wrap">
      <div className="auth-card">
        <h2 className="auth-title">Create account</h2>
        <form className="auth-form" onSubmit={onSubmit}>
          <label className="auth-label">Name</label>
          <input className="auth-input" value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} />

          <label className="auth-label">Email</label>
          <input className="auth-input" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} />

          <label className="auth-label">Password</label>
          <input className="auth-input" type="password" value={form.password} onChange={e => setForm({ ...form, password: e.target.value })} />

          <label className="auth-label">Confirm Password</label>
          <input className="auth-input" type="password" value={form.password_confirmation} onChange={e => setForm({ ...form, password_confirmation: e.target.value })} />

          {err && <p className="auth-error">{err}</p>}
          <button className="auth-button" type="submit">Sign up</button>
        </form>
        <p className="auth-meta">Have an account? <Link to="/login">Login</Link></p>
      </div>
    </div>
  );
}