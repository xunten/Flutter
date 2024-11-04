<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class One_to_One_Leaderboard extends Model
{
    use HasFactory;

    protected $table = 'tbl_one_to_one_leaderboard';
    protected $guarded = array();

    public function w_user()
    {
        return $this->belongsTo(Users::class,'w_user_id');
    }
    public function l_user()
    {
        return $this->belongsTo(Users::class,'l_user_id');
    }

}
