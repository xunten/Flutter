<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class One_to_One_challenge extends Model
{
    use HasFactory;

    protected $table = 'tbl_one_to_one_challenge';
    protected $guarded = array();

    public function c_user()
    {
        return $this->belongsTo(Users::class, 'c_user_id');
    }
    public function j_user()
    {
        return $this->belongsTo(Users::class, 'j_user_id');
    }
    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }
}
