local module = {}

function module.get_zone_around_cursor(pane)
  local cursor = pane:get_cursor_position()
  -- using x-1 here because the cursor may be one cell outside the zone
  local zone = pane:get_semantic_zone_at(cursor.x - 1, cursor.y)
  if zone then
    return pane:get_text_from_semantic_zone(zone)
  end
  return nil
end

return module
