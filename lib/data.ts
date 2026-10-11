import {createClient} from './supabase/server'
export async function getCategories(){const s=await createClient();return (await s.from('categories').select('*').order('name_en')).data??[]}
export async function getDistricts(){const s=await createClient();return (await s.from('districts').select('*').order('name_en')).data??[]}
export async function getRecentItems(limit=6){const s=await createClient();return (await s.from('items').select('*,district:districts(name_en,name_bn),category:categories(name_en,name_bn,icon),images:item_images(storage_path,sort_order)').eq('status','active').order('created_at',{ascending:false}).limit(limit)).data??[]}
export async function getStats(){const s=await createClient();const {data}=await s.rpc('get_public_stats');return data??{reported:0,found:0,lost:0,returned:0,districts:64}}
