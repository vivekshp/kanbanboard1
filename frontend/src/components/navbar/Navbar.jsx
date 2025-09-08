import { useAuth } from '../../context/AuthContext';
import './navbar.css';

export default function Navbar() {
  const { user } = useAuth();
  return (
    <header className="nav">
      <div className="nav-inner container">
        <div className="nav-brand">Kanban</div>
        <div className="nav-right">
          {user ? <span className="nav-user">{user.name}</span> : null}
        </div>
      </div>
    </header>
  );
}