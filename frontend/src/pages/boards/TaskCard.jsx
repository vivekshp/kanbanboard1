import './tasks.css';

export default function TaskCard({ task, onUpdate, onDelete, onClick }) {
    return (
      <div className="task" onClick={() => onClick?.(task)} style={{ cursor: 'pointer' }}>
        <div className="task-head">
          <div className="task-title">{task.title}</div>
          <button className="task-del" onClick={(e) => { e.stopPropagation(); onDelete(task.id); }} title="Delete">×</button>
        </div>
        {task.description ? <div className="task-desc">{task.description}</div> : null}
      </div>
    );
  }