import { Injectable, NotFoundException, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { EmergencyService } from '../services/service.entity';
import { Review } from './review.entity';

@Injectable()
@Dependencies(getRepositoryToken(Review), getRepositoryToken(EmergencyService))
export class ReviewsService {
  constructor(reviewsRepository, servicesRepository) {
    this.reviewsRepository = reviewsRepository;
    this.servicesRepository = servicesRepository;
  }

  async findAll(serviceId) {
    const query = { order: { date: 'DESC' } };
    if (serviceId) {
      query.where = { serviceId };
    }
    return this.reviewsRepository.find(query);
  }

  async create(payload) {
    const service = await this.servicesRepository.findOne({
      where: { id: payload.serviceId },
    });
    if (!service) {
      throw new NotFoundException('Service not found.');
    }

    const reviewId = 'r_' + Date.now() + '_' + Math.floor(Math.random() * 1000);
    const date = new Date().toISOString().split('T')[0];

    const review = this.reviewsRepository.create({
      id: reviewId,
      ...payload,
      date,
      service,
    });

    const saved = await this.reviewsRepository.save(review);

    // Recalculate rating and reviewCount for the service
    const reviews = await this.reviewsRepository.find({
      where: { serviceId: payload.serviceId },
    });
    const count = reviews.length;
    const sum = reviews.reduce((acc, r) => acc + r.rating, 0);
    service.reviewCount = count;
    service.rating = count > 0 ? parseFloat((sum / count).toFixed(1)) : 0;

    await this.servicesRepository.save(service);

    return saved;
  }
}
