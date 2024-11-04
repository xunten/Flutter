<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Refer_Earn_Transaction extends Model
{
    use HasFactory;

    protected $table = 'tbl_refer_earn_transaction';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'child_user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'parent_user_id' => 'integer',
        'child_user_id' => 'integer',
        'reference_code' => 'string',
        'parent_user_referred_point' => 'float',
        'child_user_earned_point' => 'float',
        'earn_point_type' => 'integer',
    ];
}
