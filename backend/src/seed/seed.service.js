import { Injectable, Logger, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import bcrypt from 'bcrypt';
import fs from 'fs';
import path from 'path';

import { User } from '../modules/users/user.entity';
import { EmergencyService } from '../modules/services/service.entity';
import { EmergencyBranch } from '../modules/branches/branch.entity';
import { Review } from '../modules/reviews/review.entity';
import { Tip } from '../modules/tips/tip.entity';

@Injectable()
@Dependencies(
  getRepositoryToken(User),
  getRepositoryToken(EmergencyService),
  getRepositoryToken(EmergencyBranch),
  getRepositoryToken(Review),
  getRepositoryToken(Tip),
)
export class SeedService {
  constructor(
    usersRepository,
    servicesRepository,
    branchesRepository,
    reviewsRepository,
    tipsRepository,
  ) {
    this.usersRepository = usersRepository;
    this.servicesRepository = servicesRepository;
    this.branchesRepository = branchesRepository;
    this.reviewsRepository = reviewsRepository;
    this.tipsRepository = tipsRepository;
    this.logger = new Logger(SeedService.name);
  }

  async seed() {
    this.logger.log('Starting database seeding...');

    const shouldSeedDefaultUser = process.env.SEED_DEFAULT_USER === 'true';
    if (shouldSeedDefaultUser) {
      const defaultEmail =
        process.env.SEED_DEFAULT_EMAIL || 'user@safereach.com';
      const defaultPassword =
        process.env.SEED_DEFAULT_PASSWORD || 'password123';
      const existingUser = await this.usersRepository.findOne({
        where: { email: defaultEmail },
      });
      if (existingUser) {
        this.logger.log(`Default user already exists: ${defaultEmail}`);
      } else {
        const passwordHash = await bcrypt.hash(defaultPassword, 10);
        const defaultUser = this.usersRepository.create({
          email: defaultEmail,
          passwordHash,
        });
        await this.usersRepository.save(defaultUser);
        this.logger.log(`Default user seeded: ${defaultEmail}`);
      }
    }

    const mockFolder = this.resolveMockFolder();

    try {
      const servicesData = this.readMockJson(mockFolder, 'items.json');
      for (const item of servicesData) {
        const service = this.servicesRepository.create(item);
        await this.servicesRepository.save(service);
      }
      this.logger.log(`Synced ${servicesData.length} services.`);
    } catch (err) {
      this.logger.error('Failed to seed services:', err.message);
    }

    try {
      const branchesData = this.readMockJson(mockFolder, 'branches.json');
      for (const item of branchesData) {
        const branch = this.branchesRepository.create(item);
        await this.branchesRepository.save(branch);
      }
      this.logger.log(`Synced ${branchesData.length} branches.`);
    } catch (err) {
      this.logger.error('Failed to seed branches:', err.message);
    }

    try {
      const reviewsData = this.readMockJson(mockFolder, 'reviews.json');
      let syncedReviews = 0;
      for (const item of reviewsData) {
        const service = await this.servicesRepository.findOne({
          where: { id: item.serviceId },
        });
        if (service) {
          const review = this.reviewsRepository.create({
            ...item,
            service,
          });
          await this.reviewsRepository.save(review);
          syncedReviews++;
        }
      }
      this.logger.log(`Synced ${syncedReviews}/${reviewsData.length} reviews.`);
    } catch (err) {
      this.logger.error('Failed to seed reviews:', err.message);
    }

    try {
      const tipsData = this.readMockJson(mockFolder, 'tips.json');
      for (const item of tipsData) {
        const tip = this.tipsRepository.create(item);
        await this.tipsRepository.save(tip);
      }
      this.logger.log(`Synced ${tipsData.length} tips.`);
    } catch (err) {
      this.logger.error('Failed to seed tips:', err.message);
    }

    this.logger.log('Database seeding completed successfully.');
  }

  resolveMockFolder() {
    const candidates = [
      path.resolve(process.cwd(), '../frontend/assets/mock'),
      path.resolve(process.cwd(), 'frontend/assets/mock'),
    ];
    const mockFolder = candidates.find((candidate) => fs.existsSync(candidate));
    if (!mockFolder) {
      throw new Error('Could not find frontend/assets/mock folder.');
    }
    return mockFolder;
  }

  readMockJson(mockFolder, fileName) {
    return JSON.parse(fs.readFileSync(path.join(mockFolder, fileName), 'utf8'));
  }
}
