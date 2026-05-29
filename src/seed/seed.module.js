import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { User } from '../modules/users/user.entity';
import { EmergencyService } from '../modules/services/service.entity';
import { EmergencyBranch } from '../modules/branches/branch.entity';
import { Review } from '../modules/reviews/review.entity';
import { Tip } from '../modules/tips/tip.entity';
import { SeedService } from './seed.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      User,
      EmergencyService,
      EmergencyBranch,
      Review,
      Tip,
    ]),
  ],
  providers: [SeedService],
  exports: [SeedService],
})
export class SeedModule {}
