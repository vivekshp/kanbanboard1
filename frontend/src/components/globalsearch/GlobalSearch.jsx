import { useState, useEffect } from 'react';
import { TextField, Autocomplete, CircularProgress, Box } from '@mui/material';
import { globalSearch, getBoards, getAssignees } from '../../lib/api';

export default function GlobalSearch() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);

  const [boards, setBoards] = useState([]);
  const [assignees, setAssignees] = useState([]);

  const [selectedBoards, setSelectedBoards] = useState([]);
  const [selectedAssignees, setSelectedAssignees] = useState([]);
  const [dateAfter, setDateAfter] = useState('');

  
  useEffect(() => {
    getBoards().then((res) => setBoards(res.data || res));
  }, []);

  
  useEffect(() => {
  if (selectedBoards.length === 0) {
    getAssignees().then((res) => setAssignees(res.data || res));
  } else {
    
    const boardIds = selectedBoards.map(b => b.id);
   
    const params = new URLSearchParams();
    boardIds.forEach(id => params.append('board_id[]', id));
    
    getAssignees(`?${params.toString()}`).then((res) => setAssignees(res.data || res));
  }
}, [selectedBoards]);


  const handleSearch = async (val) => {
    setQuery(val);
    if (!val.trim()) return setResults([]);

    setLoading(true);
    try {
      const res = await globalSearch({
        q: val,
        boards: selectedBoards.map(b => b.id),
        assignees: selectedAssignees.map(a => a.id),
        date_after: dateAfter,
      });
      setResults(res || []);
    } catch (err) {
      console.error(err);
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
  if (query.trim()) {
    handleSearch(query);
  }
}, [selectedBoards, selectedAssignees, dateAfter]);

  return (
    <Box sx={{ maxWidth: 960, margin: '0 auto', position: 'relative' }}>
      <TextField
        fullWidth
        placeholder="Search tasks, boards, assignees..."
        value={query}
        onChange={(e) => handleSearch(e.target.value)}
        size="small"
      />

      <Box sx={{ mt: 2, display: 'flex', gap: 2, flexWrap: 'wrap' }}>
        <Autocomplete
          multiple
          options={boards}
          getOptionLabel={(b) => b.title}
          value={selectedBoards}
          onChange={(_, newVal) => setSelectedBoards(newVal)}
          renderInput={(params) => <TextField {...params} label="Boards" />}
          sx={{ minWidth: 200 }}
          size="small"
        />

        
        <Autocomplete
          multiple
          options={assignees}
          getOptionLabel={(u) => u.name}
          value={selectedAssignees}
          onChange={(_, newVal) => setSelectedAssignees(newVal)}
          renderInput={(params) => <TextField {...params} label="Assignees" />}
          sx={{ minWidth: 200 }}
          size="small"
        />

        
        <TextField
          type="date"
          value={dateAfter}
          onChange={(e) => setDateAfter(e.target.value)}
          label="Created After"
          InputLabelProps={{ shrink: true }}
          sx={{ minWidth: 200 }}
          size="small"
        />
      </Box>

      {loading && <CircularProgress size={24} sx={{ position: 'absolute', top: 16, right: 16 }} />}

      <ul>
        {results.map((r) => (
          <li key={`${r.record_type}-${r.record_id}`}>
            {r.record_type === 'Task' && <strong>Task:</strong>} {r.content}
            {r.record_type === 'Board' && <strong>Board:</strong>} {r.content}
            {r.record_type === 'User' && <strong>User:</strong>} {r.content}
          </li>
        ))}
      </ul>
    </Box>
  );
}
