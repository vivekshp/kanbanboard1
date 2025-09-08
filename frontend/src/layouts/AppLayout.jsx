import Navbar from '../components/navbar/Navbar';

export default function AppLayout({ children }) {
  return (
    <>
      <Navbar />
      <main className="container">{children}</main>
    </>
  );
}