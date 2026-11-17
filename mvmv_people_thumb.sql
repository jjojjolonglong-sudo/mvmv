-- mvmv 인물 사진 칸 추가 (앱은 처음부터 이 칸에 저장하려 했는데 DB에 칸이 없어서 새 인물 저장이 실패했어요)
-- 기존 인물·출연 정보는 그대로, 빈 칸만 하나 생겨요.
alter table public.mvmv_people add column if not exists thumb text;
notify pgrst, 'reload schema';
